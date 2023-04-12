import React from 'react';
import './App.css';
import { HomePage } from './modules/home/pages/Home';
import { ChakraProvider } from '@chakra-ui/react'
import { Router } from '@reach/router';
import { ProjectsPage } from './modules/projects/pages/projects';
import { CreateProjectPage } from './modules/projects/pages/create_project';
import { RulesPage } from './modules/rules/pages/rules';
import { RulesService } from './services/rules_service';
import { ProjectsService } from './services/projects_service';

export interface RoutingProps {
  path: string;
}

const Home = (_props: RoutingProps) => <HomePage />;
const Projects = (props: RoutingProps) => <ProjectsPage {...props} />;
const CreateProject = (props: RoutingProps) => <CreateProjectPage />
const Rules = (props: RoutingProps) => <RulesPage {...props} />

const services = {
  rules: new RulesService(),
  projects: new ProjectsService(),
};

export const ServicesContext = React.createContext(services);

function App() {
  return (
    <ChakraProvider>
      <ServicesContext.Provider value={services}>
        <Router>
          <Home path='/' />
          <Projects path='/projects/:projectId' />
          <Projects path='/projects' />
          <CreateProject path='/projects/create' />
          <Rules path='/rules/:ruleId' />
          <Rules path='/rules' />
        </Router>
      </ServicesContext.Provider>
    </ChakraProvider>
  );
}

export default App;
