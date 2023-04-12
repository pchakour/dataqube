import { useState, useEffect } from 'react';
import { Sidenav } from '../../../components/Body/Body';
import { PageTemplate } from '../../../components/PageTemplate/PageTemplate';
import { ProjectChartFailure } from '../components/project/ProjectChartFailure/ProjectChartFailure';
import { ProjectHeader } from '../components/project/ProjectHeader/ProjectHeader';
import { ProjectMetricsRow } from '../components/project/ProjectMetricsRow/ProjectMetricsRow';
import { IProjectModel } from '../../../../../common/model/project_model';
import { useServices } from '../../../hooks/use_services';
import { ProjectData } from '../components/project/ProjectData/ProjectData';

const sidenav: Sidenav = {
  "Tags": [
    {
      id: 'test',
      title: 'Test',
      path: '/'
    }
  ],
  "Severity": [
    {
      id: 'test',
      title: 'Test',
      path: '/'
    }
  ]
};

interface ProjectPageProps {
  projectId: string;
}

export function ProjectPage({ projectId }: ProjectPageProps) {
  const [project, setProject] = useState<IProjectModel>();
  const services = useServices();

  useEffect(() => {
    services.projects.get(projectId).then((response) => {
      console.log('response', response)
      setProject(response)
    });
  }, [services, projectId]);

  return (
    <PageTemplate sidenav={sidenav} select='projects'>
      <ProjectHeader name={project?.name || '--'} />
      <ProjectMetricsRow projectId={projectId} />
      <ProjectChartFailure projectId={projectId} />
      <ProjectData projectId={projectId} />
    </PageTemplate>
  );
}
