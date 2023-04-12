import Chart from 'chart.js/auto';
import { useEffect, useRef, useState } from 'react';
import { useServices } from '../../../../../hooks/use_services';
import './ProjectChartFailure.css';

interface ProjectChartFailureProps {
  projectId: string;
  className?: string;
}

export function ProjectChartFailure({ projectId, className }: ProjectChartFailureProps) {
  const chartContainerRef = useRef<HTMLCanvasElement>(null);
  const services = useServices();
  const [failedTags, setFailedTags] = useState<any[]>();

  useEffect(() => {
    services.projects.getFailedTags(projectId).then((response) => {
      setFailedTags(response);
    });
  }, [services, projectId]);

  useEffect(() => {
    let chart: Chart;

    if (chartContainerRef.current) {
      chart = new Chart(chartContainerRef.current, {
        type: 'bar',
        data: {
          labels: failedTags?.map(failedTag => failedTag.key) || [],
          datasets: [{
            label: '# of failures by tags',
            data: failedTags?.map(failedTag => failedTag.doc_count) || [],
            borderWidth: 1
          }]
        },
        options: {
          scales: {
            y: {
              beginAtZero: true
            }
          }
        }
      });
    }

    return () => {
      if (chart) {
        chart.destroy();
      }
    }
  }, [chartContainerRef, failedTags]);

  return (
    <div className={`chart-failure ${className || ''}`}>
      <canvas ref={chartContainerRef}></canvas>
    </div>
  );
}