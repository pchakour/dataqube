import React from "react";
import { RoutingProps } from "../../../App";
import { ListPage } from "./list";
import { ProjectPage } from "./project";

interface ProjectsPageProps extends RoutingProps {
  projectId?: string;
}

export function ProjectsPage(props: ProjectsPageProps) {
  return (
    <>
    {props.projectId ?
      <ProjectPage projectId={props.projectId} /> :
      <ListPage />
    }
    </>
  );
}