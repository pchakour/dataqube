import { Button, StackDivider, VStack } from '@chakra-ui/react';
import { PageTemplate } from '../../../components/PageTemplate/PageTemplate';
import { ProjectItem } from '../components/list/project_item';
import { navigate } from '@reach/router';
import { useServices } from '../../../hooks/use_services';
import { useEffect, useState, Fragment } from 'react';
import { IProjectModel } from '../../../../../common/model/project_model';

export function ListPage() {
  const services = useServices();
  const [projects, setProjects] = useState<IProjectModel[]>([]);

  useEffect(() => {
    services.projects.search().then((projects) => {
      setProjects(projects);
    });
  }, [services]);

  return (
    <PageTemplate
      marginTop={20}
      marginBottom={20}
      select='projects'
      title='Projects'
      rightButtons={[<Button onClick={() => navigate('/projects/create')}>New</Button>]}
    >
      <VStack
        divider={<StackDivider borderColor='gray.200' />}
        spacing={4}
        align='stretch'
      >
        { projects.map((project) => (
          <Fragment key={project.id}>
            <ProjectItem project={project} />
          </Fragment>
        ))}
      </VStack>
    </PageTemplate>
  );
}