import React from 'react';
import { Badge, Box, Center, Divider, Flex, Heading } from '@chakra-ui/react';
import { ProjectVersionSelector } from '../ProjectVersionSelector/ProjectVersionSelector';
import './ProjectHeader.css';

interface ProjectHeaderProps {
  name: string;
}

export function ProjectHeader({ name }: ProjectHeaderProps) {
  return (
    <div className='project-header'>
      <Flex>
        <Center flexGrow={0}>
          <Heading>{name}</Heading>
        </Center>
        <Box flexGrow={0}>
          <ProjectVersionSelector />
        </Box>
        <Center>
          <Badge colorScheme='red'>failed</Badge>
        </Center>
      </Flex>
      <Divider />
    </div>
  );
}