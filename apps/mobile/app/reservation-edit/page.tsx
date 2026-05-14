// @ts-nocheck
'use client';

import React, { useEffect, useMemo, useState } from 'react';
import Link from 'next/link';
import { useRouter } from 'next/navigation';
import supabase from '@/lib/supabase';
import {
  ArrowLeft,
  RefreshCw,
  Search,
  Save,
  FilePenLine,
  Ship,
  Plane,
  Building,
  MapPin,
  Car,
  Bus,
  Package,
  Clock,
  CheckCircle,
  XCircle,
} from 'lucide-react';

interface ServiceReservation {
  re_id: string;
  re_type: string;
  re_status: string;
  total_amount?: number;
}

interface ReservationItem {
  re_quote_id: string | null;
  re_created_at: string;
  users: {
    id: string;
    name: string;
    email: string;
    phone: string;
  } | null;
  quote: { title: string } | null;
  services: ServiceReservation[];
}

type StatusType =
  | 'all'
  | 'pending'
  | 'approved'
  | 'confirmed'
  | 'processing'
  | 'cancelled'
  | 'completed';

type ServiceTypeFilter =
  | 'all'
  | 'cruise'
  | 'airport'
  | 'hotel'
  | 'tour'
  | 'rentcar'
  | 'vehicle'
  | 'sht'
  | 'package';

const SERVICE_TYPE_MAP: Record<ServiceTypeFilter, string[]> = {
  all: [],
  cruise: ['cruise'],
  airport: ['airport'],
  hotel: ['hotel'],
  tour: ['tour'],
  rentcar: ['rentcar'],
  vehicle: ['car', 'vehicle'],
  sht: ['sht', 'car_sht', 'reservation_car_sht'],
  package: ['package'],
};

export default function ReservationEditPage() {
  const router = useRouter();
  const [reservations, setReservations] = useState<ReservationItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const [statusFilter, setStatusFilter] = useState<StatusType>('pending');
  const [typeFilter, setTypeFilter] = useState<ServiceTypeFilter>('all');
  const [searchQuery, setSearchQuery] = useState('');

  const [editStatusMap, setEditStatusMap] = useState<Record<string, string>>({});
  const [savingMap, setSavingMap] = useState<Record<string, boolean>>({});

  useEffect(() => {
    loadReservations();
  }, []);

  const loadReservations = async () => {
    try {
      setLoading(true);
      setError(null);

      const { data: rows, error: rowsErr } = await supabase
        .from('reservation')
        .select('re_id, re_type, re_status, re_created_at, re_quote_id, re_user_id, total_amount')
        .order('re_created_at', { ascending: false });

      if (rowsErr) throw rowsErr;
      const baseRows = rows || [];

      const userIds = [...new Set(baseRows.map((r) => r.re_user_id).filter(Boolean))];
      const quoteIds = [...new Set(baseRows.map((r) => r.re_quote_id).filter(Boolean))];

      let usersData: any[] = [];
      let quotesData: any[] = [];

      const CHUNK = 100;

      for (let i = 0; i < userIds.length; i += CHUNK) {
        const chunk = userIds.slice(i, i + CHUNK);
        const { data } = await supabase
          .from('users')
          .select('id, name, email, phone_number')
          .in('id', chunk);
        usersData = usersData.concat(data || []);
      }

      for (let i = 0; i < quoteIds.length; i += CHUNK) {
        const chunk = quoteIds.slice(i, i + CHUNK);
        const { data } = await supabase.from('quote').select('id, title').in('id', chunk);
        quotesData = quotesData.concat(data || []);
      }

      const userMap = new Map(usersData.map((u) => [u.id, u]));
      const quoteMap = new Map(quotesData.map((q) => [q.id, q]));

      const grouped: Record<string, ReservationItem> = {};

      baseRows.forEach((r) => {
        const key = r.re_quote_id || r.re_id;
        if (!grouped[key]) {
          const u = userMap.get(r.re_user_id);
          grouped[key] = {
            re_quote_id: r.re_quote_id,
            re_created_at: r.re_created_at,
            users: u
              ? {
                  id: u.id,
                  name: u.name || (u.email ? u.email.split('@')[0] : '정보 없음'),
                  email: u.email || '',
                  phone: u.phone_number || '',
                }
              : null,
            quote: r.re_quote_id ? quoteMap.get(r.re_quote_id) || null : null,
            services: [],
          };
        }

        grouped[key].services.push({
          re_id: r.re_id,
          re_type: r.re_type,
          re_status: r.re_status,
          total_amount: r.total_amount || 0,
        });
      });

      const list = Object.values(grouped);
      setReservations(list);

      const initialEditStatus: Record<string, string> = {};
      list.forEach((group) => {
        group.services.forEach((s) => {
          initialEditStatus[s.re_id] = s.re_status;
        });
      });
      setEditStatusMap(initialEditStatus);
    } catch (err: any) {
      setError('예약수정 목록을 불러오지 못했습니다.');
      setReservations([]);
    } finally {
      setLoading(false);
    }
  };

  const filteredReservations = useMemo(() => {
    const query = searchQuery.trim().toLowerCase();

    return reservations
      .map((group) => {
        const filteredServices = group.services.filter((s) => {
          const matchStatus = statusFilter === 'all' ? true : s.re_status === statusFilter;

          const matchType =
            typeFilter === 'all' ? true : SERVICE_TYPE_MAP[typeFilter].includes(s.re_type);

          const matchSearch =
            !query ||
            group.users?.name?.toLowerCase().includes(query) ||
            group.users?.email?.toLowerCase().includes(query) ||
            group.quote?.title?.toLowerCase().includes(query) ||
            s.re_id.toLowerCase().includes(query);

          return matchStatus && matchType && matchSearch;
        });

        if (filteredServices.length === 0) return null;

        return {
          ...group,
          services: filteredServices,
        };
      })
      .filter(Boolean) as ReservationItem[];
  }, [reservations, statusFilter, typeFilter, searchQuery]);

  const handleSaveServiceStatus = async (service: ServiceReservation) => {
    const nextStatus = editStatusMap[service.re_id] || service.re_status;
    if (nextStatus === service.re_status) {
      alert('변경된 상태가 없습니다.');
      return;
    }

    try {
      setSavingMap((prev) => ({ ...prev, [service.re_id]: true }));

      const { error: updateErr } = await supabase
        .from('reservation')
        .update({ re_status: nextStatus })
        .eq('re_id', service.re_id);

      if (updateErr) throw updateErr;

      setReservations((prev) =>
        prev.map((group) => ({
          ...group,
          services: group.services.map((s) =>
            s.re_id === service.re_id ? { ...s, re_status: nextStatus } : s
          ),
        }))
      );

      alert('상태가 수정되었습니다.');
    } catch (err: any) {
      alert(`수정 실패: ${err.message || '알 수 없는 오류'}`);
    } finally {
      setSavingMap((prev) => ({ ...prev, [service.re_id]: false }));
    }
  };

  const getTypeIcon = (type: string) => {
    const map: Record<string, React.ReactNode> = {
      cruise: <Ship className="w-3.5 h-3.5 text-blue-600" />,
      airport: <Plane className="w-3.5 h-3.5 text-green-600" />,
      hotel: <Building className="w-3.5 h-3.5 text-purple-600" />,
      tour: <MapPin className="w-3.5 h-3.5 text-orange-600" />,
      rentcar: <Car className="w-3.5 h-3.5 text-red-600" />,
      car: <Car className="w-3.5 h-3.5 text-cyan-600" />,
      vehicle: <Car className="w-3.5 h-3.5 text-cyan-600" />,
      sht: <Bus className="w-3.5 h-3.5 text-indigo-600" />,
      car_sht: <Bus className="w-3.5 h-3.5 text-indigo-600" />,
      package: <Package className="w-3.5 h-3.5 text-pink-600" />,
    };
    return map[type] || <Clock className="w-3.5 h-3.5 text-gray-600" />;
  };

  const getTypeName = (type: string) => {
    return (
      {
        cruise: '크루즈',
        airport: '공항',
        hotel: '호텔',
        tour: '투어',
        rentcar: '렌터카',
        car: '크루즈 차량',
        vehicle: '크루즈 차량',
        sht: '스하차량',
        car_sht: '스하차량',
        package: '패키지',
      }[type] || type
    );
  };

  const getStatusIcon = (status: string) => {
    if (status === 'confirmed') return <CheckCircle className="w-3.5 h-3.5 text-green-600" />;
    if (status === 'cancelled') return <XCircle className="w-3.5 h-3.5 text-red-600" />;
    return <Clock className="w-3.5 h-3.5 text-yellow-600" />;
  };

  const getStatusText = (status: string) => {
    return (
      {
        pending: '대기중',
        approved: '승인',
        confirmed: '확정',
        processing: '처리중',
        cancelled: '취소',
        completed: '완료',
      }[status] || status
    );
  };

  const getDetailEditPath = (service: ServiceReservation) => {
    if (service.re_type === 'cruise') return `/reservation-edit/cruise?id=${service.re_id}`;
    if (service.re_type === 'airport') return `/reservation-edit/airport?id=${service.re_id}`;
    if (service.re_type === 'car' || service.re_type === 'vehicle') {
      return `/reservation-edit/vehicle?id=${service.re_id}`;
    }
    return null;
  };

  return (
    <div className="min-h-screen bg-gray-50 pb-20">
      <div className="bg-white border-b shadow-sm px-4 py-3">
        <div className="flex items-center gap-3 mb-3">
          <Link href="/" className="p-1.5 rounded-lg hover:bg-gray-100">
            <ArrowLeft className="w-5 h-5 text-gray-600" />
          </Link>
          <h1 className="text-lg font-bold text-gray-800 flex-1">📝 예약 수정</h1>
          <button
            onClick={loadReservations}
            className="p-2 rounded-lg bg-blue-500 text-white hover:bg-blue-600"
          >
            <RefreshCw className="w-4 h-4" />
          </button>
        </div>

        <div className="space-y-2">
          <div className="grid grid-cols-2 gap-2">
            <Select
              value={statusFilter}
              onChange={(e) => setStatusFilter(e.target.value as StatusType)}
              options={[
                ['all', '전체 상태'],
                ['pending', '대기중'],
                ['approved', '승인'],
                ['processing', '처리중'],
                ['confirmed', '확정'],
                ['cancelled', '취소'],
                ['completed', '완료'],
              ]}
            />
            <Select
              value={typeFilter}
              onChange={(e) => setTypeFilter(e.target.value as ServiceTypeFilter)}
              options={[
                ['all', '전체 서비스'],
                ['cruise', '크루즈'],
                ['airport', '공항'],
                ['hotel', '호텔'],
                ['tour', '투어'],
                ['rentcar', '렌터카'],
                ['vehicle', '크루즈 차량'],
                ['sht', '스하차량'],
                ['package', '패키지'],
              ]}
            />
          </div>

          <div className="relative">
            <Search className="w-4 h-4 text-gray-400 absolute left-3 top-1/2 -translate-y-1/2" />
            <input
              type="text"
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              placeholder="고객명, 이메일, 여행명, 예약ID 검색"
              className="w-full pl-9 pr-3 py-2 text-sm border rounded-lg bg-gray-50"
            />
          </div>
        </div>
      </div>

      <div className="px-4 py-4">
        {loading ? (
          <div className="flex flex-col items-center justify-center py-20">
            <div className="w-10 h-10 border-4 border-blue-200 border-t-blue-500 rounded-full animate-spin" />
            <p className="mt-4 text-sm text-gray-500">예약수정 목록을 불러오는 중...</p>
          </div>
        ) : error ? (
          <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg text-sm">
            ⚠️ {error}
          </div>
        ) : filteredReservations.length === 0 ? (
          <div className="text-center py-20 text-sm text-gray-500">표시할 예약이 없습니다.</div>
        ) : (
          <div className="space-y-3">
            <p className="text-sm text-gray-500">총 {filteredReservations.length}개 예약 그룹</p>

            {filteredReservations.map((group) => (
              <div
                key={group.re_quote_id || group.services[0]?.re_id}
                className="bg-white rounded-xl border border-gray-100 shadow-sm p-4"
              >
                <div className="mb-3">
                  <div className="font-semibold text-gray-800">{group.users?.name || '정보 없음'}</div>
                  <div className="text-xs text-gray-500">{group.users?.email || '이메일 없음'}</div>
                  <div className="text-xs text-gray-500 mt-1">
                    여행명: {group.quote?.title || '미지정'}
                  </div>
                </div>

                <div className="space-y-2">
                  {group.services.map((service) => {
                    const saving = !!savingMap[service.re_id];
                    const selectedStatus = editStatusMap[service.re_id] || service.re_status;

                    const handleCardClick = () => {
                      const path = getDetailEditPath(service);
                      if (path) {
                        router.push(path);
                      }
                    };

                    return (
                      <div
                        key={service.re_id}
                        onClick={handleCardClick}
                        className={`border rounded-lg p-3 bg-gray-50 ${
                          getDetailEditPath(service) ? 'cursor-pointer hover:bg-gray-100 hover:shadow-md transition-all' : ''
                        }`}
                      >
                        <div className="flex items-center justify-between gap-2 mb-2">
                          <div className="flex items-center gap-1.5 text-sm font-medium text-gray-700">
                            {getTypeIcon(service.re_type)}
                            {getTypeName(service.re_type)}
                          </div>
                          <div className="flex items-center gap-1 text-xs text-gray-500">
                            {getStatusIcon(service.re_status)}
                            현재: {getStatusText(service.re_status)}
                          </div>
                        </div>

                        <div className="text-xs text-gray-500 mb-2 break-all">예약ID: {service.re_id}</div>

                        <div className="grid grid-cols-[1fr_auto] gap-2 items-center">
                          <select
                            value={selectedStatus}
                            onChange={(e) => {
                              e.stopPropagation();
                              setEditStatusMap((prev) => ({ ...prev, [service.re_id]: e.target.value }));
                            }}
                            className="w-full px-2 py-2 text-sm border rounded-lg bg-white"
                          >
                            <option value="pending">대기중</option>
                            <option value="approved">승인</option>
                            <option value="processing">처리중</option>
                            <option value="confirmed">확정</option>
                            <option value="cancelled">취소</option>
                            <option value="completed">완료</option>
                          </select>

                          <button
                            onClick={(e) => {
                              e.stopPropagation();
                              handleSaveServiceStatus(service);
                            }}
                            disabled={saving}
                            className={`px-3 py-2 rounded-lg text-sm font-medium inline-flex items-center gap-1 ${
                              saving
                                ? 'bg-gray-200 text-gray-500'
                                : 'bg-blue-500 text-white hover:bg-blue-600'
                            }`}
                          >
                            <Save className="w-4 h-4" />
                            {saving ? '저장중' : '저장'}
                          </button>
                        </div>
                      </div>
                    );
                  })}
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}

function Select({
  value,
  onChange,
  options,
}: {
  value: string;
  onChange: (e: React.ChangeEvent<HTMLSelectElement>) => void;
  options: [string, string][];
}) {
  return (
    <select value={value} onChange={onChange} className="w-full px-2 py-2 text-sm border rounded-lg bg-white">
      {options.map(([val, text]) => (
        <option key={val} value={val}>
          {text}
        </option>
      ))}
    </select>
  );
}
