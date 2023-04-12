import { Wrap, WrapItem } from '@chakra-ui/react';
import { useEffect, useState } from 'react';
import { ProjectMetric } from '../ProjectMetric/ProjectMetric';
import { useServices } from '../../../../../hooks/use_services';
import { IProjectMetrics } from '../../../../../../../common/types';

interface ProjectMetricsRowProps {
  projectId: string;
}

export function ProjectMetricsRow({ projectId }: ProjectMetricsRowProps) {
  const services = useServices();
  const [count, setCount] = useState<number>();
  const [failed, setFailed] = useState<number>();
  const [success, setSuccess] = useState<number>();
  
  
  useEffect(() => {
    services.projects.getMetrics(projectId).then((metrics) => {
      if (metrics) {
        setCount(metrics.count);
        setFailed(metrics.failed);
        setSuccess(metrics.count - metrics.failed);
      }
    });
  }, [projectId, services]);

  return (
    <Wrap>
      <WrapItem>
        <ProjectMetric label="Total parsed" metric={count} />
      </WrapItem>
      <WrapItem>
        <ProjectMetric label="Success" metric={success} />
      </WrapItem>
      <WrapItem>
        <ProjectMetric label="Failed" metric={failed} />
      </WrapItem>
    </Wrap>
  );
}