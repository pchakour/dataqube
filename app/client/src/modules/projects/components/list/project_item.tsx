import React from "react";
import { Badge } from '@chakra-ui/react'
import { Box, Link } from "@chakra-ui/react";
import { Link as ReachLink } from "@reach/router";
import { ProjectMetricsRow } from "../project/ProjectMetricsRow/ProjectMetricsRow";
import { IProjectModel } from '../../../../../../common/model/project_model';

interface ProjectItemProps {
  project: IProjectModel;
}

export function ProjectItem({ project }: ProjectItemProps) {
  return (
    <Box h='100px' bg="gray.100" border='1px solid #ddd' padding={5} paddingTop={2}>
      <Link color="blue.500" fontWeight='bold' as={ReachLink} to={`/projects/${project.id}`}>{ project.name }</Link>
      <Badge colorScheme='red' color='red.800' rounded={5}>Failed</Badge>
      <ProjectMetricsRow projectId={project.id!} />
    </Box>
  );
}