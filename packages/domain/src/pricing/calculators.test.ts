import { describe, expect, it } from 'vitest';
import { AirportPriceCalculator } from './airport';
import { HotelPriceCalculator } from './hotel';
import { RentcarPriceCalculator } from './rentcar';
import { calculateReservationPricing } from './reservation';
import { TourPriceCalculator } from './tour';

type QueryRow = Record<string, unknown> | null;

function createSupabaseMock(row: QueryRow, error: { message: string } | null = null) {
  const chain = {
    select: () => chain,
    eq: () => chain,
    limit: () => chain,
    maybeSingle: async () => ({ data: row, error }),
  };

  return {
    from: () => chain,
  } as unknown;
}

describe('pricing calculators', () => {
  it('HotelPriceCalculator.calculate returns subtotal by nights and rooms', async () => {
    const calculator = new HotelPriceCalculator(createSupabaseMock({ base_price: 150000 }) as never);

    const result = await calculator.calculate({
      hotel_price_code: 'HOTEL_TEST',
      checkin_date: '2026-06-01',
      checkout_date: '2026-06-03',
      room_count: 2,
    });

    expect(result.base_price).toBe(150000);
    expect(result.nights).toBe(2);
    expect(result.room_count).toBe(2);
    expect(result.subtotal).toBe(600000); // 150000 * 2nights * 2rooms
  });

  it('AirportPriceCalculator.calculate returns unit x quantity', async () => {
    const calculator = new AirportPriceCalculator(createSupabaseMock({ price: 50000 }) as never);

    const result = await calculator.calculate({
      airport_code: 'HAN_PICKUP',
      service_type: '픽업',
      quantity: 3,
    });

    expect(result.unit_price).toBe(50000);
    expect(result.quantity).toBe(3);
    expect(result.subtotal).toBe(150000);
  });

  it('RentcarPriceCalculator.calculate returns unit x quantity', async () => {
    const calculator = new RentcarPriceCalculator(createSupabaseMock({ price: 80000 }) as never);

    const result = await calculator.calculate({
      rent_code: 'RT_TEST',
      quantity: 4,
    });

    expect(result.unit_price).toBe(80000);
    expect(result.quantity).toBe(4);
    expect(result.subtotal).toBe(320000);
  });

  it('TourPriceCalculator.calculate sums adult/child subtotal', async () => {
    // tour_pricing에서 adult_price/child_price 조회 (또는 price_per_person 대체)
    const calculator = new TourPriceCalculator(
      createSupabaseMock({ tour_code: 'TOUR_TEST', adult_price: 70000, child_price: 30000 }) as never,
    );

    const result = await calculator.calculate({
      tour_code: 'TOUR_TEST',
      adult_count: 2,
      child_count: 1,
    });

    // adult_price: 70000, child_price: 30000이므로
    // subtotal = 70000*2 + 30000*1 = 170000
    expect(result.adult_price).toBe(70000);
    expect(result.child_price).toBe(30000);
    expect(result.subtotal).toBe(170000); // 70000*2 + 30000*1
  });

  it('HotelPriceCalculator.calculate throws when query fails', async () => {
    const calculator = new HotelPriceCalculator(
      createSupabaseMock(null, { message: 'db error' }) as never,
    );

    await expect(
      calculator.calculate({
        hotel_price_code: 'HOTEL_ERR',
        checkin_date: '2026-06-01',
        checkout_date: '2026-06-02',
      }),
    ).rejects.toThrow('호텔 가격 조회 실패: db error');
  });

  it('calculateReservationPricing applies discount and additional fee consistently', () => {
    const result = calculateReservationPricing({
      serviceType: 'hotel',
      baseTotal: 100000,
      discountRate: 10,
      manualDiscountAmount: 5000,
      additionalFee: 20000,
      additionalFeeDetail: 'late checkout',
      lineItems: [{ label: 'room', unit_price: 50000, quantity: 2, total: 100000 }],
    });

    expect(result.discount_rate_amount).toBe(10000);
    expect(result.discount_manual_amount).toBe(5000);
    expect(result.discount_amount).toBe(15000);
    expect(result.discounted_subtotal).toBe(85000);
    expect(result.total_amount).toBe(105000);
    expect(result.price_breakdown.schema).toBe('reservation_pricing_v1');
  });
});
