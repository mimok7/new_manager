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

async function verifyMigration() {
  console.log('🔍 Verification: Check reservation_cruise.unit_price migration status');
  console.log('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

  try {
    // Get total count
    const { count: totalCount } = await supabase
      .from('reservation_cruise')
      .select('*', { count: 'exact', head: true });

    // Get empty count
    const { count: emptyCount } = await supabase
      .from('reservation_cruise')
      .select('*', { count: 'exact', head: true })
      .or('unit_price.is.null,unit_price.eq.0');

    const filledCount = (totalCount || 0) - (emptyCount || 0);
    const fillPercentage = totalCount ? ((filledCount / totalCount) * 100).toFixed(1) : 0;
    const emptyPercentage = totalCount ? ((emptyCount / totalCount) * 100).toFixed(1) : 0;

    console.log('📊 Migration Statistics:');
    console.log(`   Total records: ${totalCount}`);
    console.log(`   Filled: ${filledCount} (${fillPercentage}%)`);
    console.log(`   Empty: ${emptyCount} (${emptyPercentage}%)\n`);

    if (emptyCount === 0 || emptyCount === null) {
      console.log('✅ All unit_price fields are filled!\n');
    } else {
      console.log(`⚠️  Still ${emptyCount} empty records\n`);
      
      // Show sample of empty records
      const { data: samples } = await supabase
        .from('reservation_cruise')
        .select('id, room_price_code, unit_price, created_at')
        .or('unit_price.is.null,unit_price.eq.0')
        .limit(5);

      if (samples && samples.length > 0) {
        console.log('   Sample of empty records:');
        samples.forEach(r => {
          console.log(`   - ID: ${r.id}`);
          console.log(`     room_price_code: ${r.room_price_code || '(null)'}`);
          console.log(`     unit_price: ${r.unit_price || '(null)'}`);
        });
      }
    }

    console.log('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

  } catch (error) {
    console.error('❌ Verification failed:', error.message, '\n');
    process.exit(1);
  }
}

verifyMigration();
