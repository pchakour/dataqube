import { Stat, StatLabel, StatNumber } from '@chakra-ui/react';
import React from 'react';

interface ProjectMetricProps {
  label: string;
  metric?: number;
}

export function ProjectMetric({ label, metric }: ProjectMetricProps) {
  return (
    <Stat>
      <StatLabel>{label}</StatLabel>
      <StatNumber>{metric !== undefined ? metric : '--'}</StatNumber>
    </Stat>
  );
}