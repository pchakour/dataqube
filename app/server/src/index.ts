import express from 'express';
import { Client } from '@elastic/elasticsearch';
import { RulesService } from './services/rules_service';
import { addRoutes as addRulesRoutes } from './routes/rules';
import { addRoutes as addProjectsRoutes } from './routes/projects';
import { RulesRequestHandler } from './request_handlers/rules_request_handler';
import { ProjectsRequestHandler } from './request_handlers/projects_request_handler';
import cors from 'cors';
import { ProjectsService } from './services/projects_service';

const PORT = process.env.PORT || 3001;

const app = express();
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

const esClient = new Client({
  node: 'http://localhost:9200',
});


app.listen(PORT, () => {
  console.log(`Server listening on ${PORT}`);
});

async function start() {
  const rulesService = new RulesService();
  const projectsService = new ProjectsService();
  const rulesServiceStart = await rulesService.start(esClient);
  const projectsServiceStart = await projectsService.start(esClient);
  
  const rulesRequestHandler = new RulesRequestHandler({ rulesService: rulesServiceStart });
  const projectsRequestHandler = new ProjectsRequestHandler({ projectsService: projectsServiceStart });

  addRulesRoutes(app, rulesRequestHandler);
  addProjectsRoutes(app, projectsRequestHandler);
}

start();
