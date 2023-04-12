import { useEffect, useState } from 'react';
import { useServices } from '../../../../../hooks/use_services';
import { Table, TableContainer, Tbody, Td, Tfoot, Th, Thead, Tr } from '@chakra-ui/react';

interface ProjectDataProps {
  projectId: string;
}

export function ProjectData({ projectId }: ProjectDataProps) {
  const services = useServices();
  const [data, setData] = useState<any>({ total: 0, hits: [] });

  useEffect(() => {
    services.projects.getData(projectId).then((response) => {
      console.log(response);
      setData(response);
    });
  }, [services, projectId]);

  return (
    <div>
      <h2>ProjectData</h2>
      <TableContainer>
        <Table variant='simple'>
          <Thead>
            <Tr>
              <Th>Tag</Th>
              <Th>message</Th>
            </Tr>
          </Thead>
          <Tbody>
          {data.hits.map((hit: any) => (
            <Tr key={hit._id}>
              <Td>{hit._source['_dataqube.quality'].rule_tag}</Td>
              <Td>{hit._source.message}</Td>
            </Tr>
          ))}
          </Tbody>
          <Tfoot>
            <Tr>
              <Th>Tag</Th>
              <Th>Message</Th>
            </Tr>
          </Tfoot>
        </Table>
      </TableContainer>
    </div>
  );
}