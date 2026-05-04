'use client';

import React, { useMemo } from 'react';
import UserReservationDetailModal from '@/components/UserReservationDetailModal';
import PackageReservationDetailModal from '@/components/PackageReservationDetailModal';

interface ReservationDetailModalSwitchProps {
  isOpen: boolean;
  onClose: () => void;
  userInfo: any;
  allUserServices: any[];
  loading: boolean;
}

export default function ReservationDetailModalSwitch({
  isOpen,
  onClose,
  userInfo,
  allUserServices,
  loading,
}: ReservationDetailModalSwitchProps) {
  const hasPackageDetails = useMemo(
    () => (allUserServices || []).some((s: any) => s?.serviceType === 'package' || s?.isPackageService),
    [allUserServices]
  );

  if (hasPackageDetails) {
    return (
      <PackageReservationDetailModal
        isOpen={isOpen}
        onClose={onClose}
        userInfo={userInfo}
        allUserServices={allUserServices}
        loading={loading}
      />
    );
  }

  return (
    <UserReservationDetailModal
      isOpen={isOpen}
      onClose={onClose}
      userInfo={userInfo}
      allUserServices={allUserServices}
      loading={loading}
    />
  );
}
