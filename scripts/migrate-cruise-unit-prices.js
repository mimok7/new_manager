#!/usr/bin/env node
'use strict';

const { createClient } = require('@supabase/supabase-js');

const SUPABASE_URL = process.env.NEXT_PUBLIC_SUPABASE_URL;
const SUPABASE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;

if (!SUPABASE_URL || !SUPABASE_KEY) {
  console.error('❌ Environment variables required:');
  console.error('   NEXT_PUBLIC_SUPABASE_URL');
  console.error('   SUPABASE_SERVICE_ROLE_KEY');
  process.exit(1);
}

const supabase = createClient(SUPABASE_URL, SUPABASE_KEY);

async function migrateUnitPrices() {
  console.log('🔄 Migration: Fill empty reservation_cruise.unit_price from cruise_rate_card');
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

  try {
    // Step 1: Get all reservation_cruise records with null or 0 unit_price
    console.log('📋 Step 1: Fetching reservation_cruise records with empty unit_price...');
    const { data: emptyRecords, error: fetchErr } = await supabase
      .from('reservation_cruise')
      .select('id, reservation_id, room_price_code, unit_price')
      .or('unit_price.is.null,unit_price.eq.0')
      .limit(10000);

    if (fetchErr) {
      throw new Error(`Failed to fetch empty records: ${fetchErr.message}`);
    }

    console.log(`   Found ${emptyRecords?.length || 0} records with empty unit_price\n`);

    if (!emptyRecords || emptyRecords.length === 0) {
      console.log('✅ No records to migrate\n');
      return;
    }

    // Step 2: Group by room_price_code and fetch corresponding cruise_rate_card records
    console.log('📋 Step 2: Fetching cruise_rate_card price data...');
    const roomPriceCodes = [...new Set(emptyRecords.map(r => r.room_price_code).filter(Boolean))];
    
    // Filter only valid UUIDs (v4 format)
    const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
    const validUuids = roomPriceCodes.filter(code => uuidRegex.test(code));
    const invalidCodes = roomPriceCodes.filter(code => !uuidRegex.test(code));
    
    console.log(`   Total unique room_price_codes: ${roomPriceCodes.length}`);
    console.log(`   Valid UUIDs: ${validUuids.length}`);
    if (invalidCodes.length > 0) {
      console.log(`   ⚠️  Non-UUID codes (will skip): ${invalidCodes.length}`);
      console.log(`       Examples: ${invalidCodes.slice(0, 3).join(', ')}`);
    }

    if (validUuids.length === 0) {
      console.log('\n✅ No valid UUIDs to match\n');
      return;
    }

    const { data: priceCards, error: priceErr } = await supabase
      .from('cruise_rate_card')
      .select('id, price_adult')
      .in('id', validUuids);

    if (priceErr) {
      throw new Error(`Failed to fetch cruise_rate_card: ${priceErr.message}`);
    }

    const priceMap = new Map((priceCards || []).map(card => [card.id, Number(card.price_adult) || 0]));
    console.log(`   Loaded ${priceCards?.length || 0} price cards\n`);

    // Step 3: Prepare update batch
    console.log('📋 Step 3: Preparing update batch...');
    const toUpdate = emptyRecords
      .filter(record => {
        const newPrice = priceMap.get(record.room_price_code);
        return newPrice && newPrice > 0;
      })
      .map(record => ({
        id: record.id,
        room_price_code: record.room_price_code,
        unit_price: priceMap.get(record.room_price_code),
      }));

    console.log(`   Ready to update: ${toUpdate.length} records`);
    const skipped = emptyRecords.length - toUpdate.length;
    if (skipped > 0) {
      console.log(`   ⚠️  Skipped: ${skipped} records (no matching price card or price is 0)\n`);
    }

    if (toUpdate.length === 0) {
      console.log('✅ No records to update after filtering\n');
      return;
    }

    // Step 4: Execute batch update
    console.log('📋 Step 4: Executing batch updates...');
    const BATCH_SIZE = 100;
    let successCount = 0;
    let errorCount = 0;

    for (let i = 0; i < toUpdate.length; i += BATCH_SIZE) {
      const batch = toUpdate.slice(i, i + BATCH_SIZE);
      const batchNum = Math.floor(i / BATCH_SIZE) + 1;
      const totalBatches = Math.ceil(toUpdate.length / BATCH_SIZE);
      
      console.log(`   Batch ${batchNum}/${totalBatches} (${batch.length} records)...`);

      for (const record of batch) {
        const { error: updateErr } = await supabase
          .from('reservation_cruise')
          .update({ unit_price: record.unit_price })
          .eq('id', record.id);

        if (updateErr) {
          console.error(`      ❌ ID ${record.id}: ${updateErr.message}`);
          errorCount++;
        } else {
          successCount++;
        }
      }
    }

    console.log('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    console.log('✅ Migration complete!');
    console.log(`   ✓ Updated: ${successCount}`);
    if (errorCount > 0) console.log(`   ✗ Failed: ${errorCount}`);
    if (skipped > 0) console.log(`   ⊘ Skipped: ${skipped}`);
    console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

  } catch (error) {
    console.error('❌ Migration failed:', error.message, '\n');
    process.exit(1);
  }
}

migrateUnitPrices();
