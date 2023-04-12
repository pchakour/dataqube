import { Express, Request } from 'express';
import { ProjectsRequestHandler } from 'src/request_handlers/projects_request_handler';
import { query } from 'express-validator';

export function addRoutes(app: Express, projectsRequestHandler: ProjectsRequestHandler) {
  app.put('/api/projects', async (req, res) => {
    return projectsRequestHandler.save(req, res);
  });

  app.get('/api/projects', async (req, res) => {
    return projectsRequestHandler.search(req, res);
  });

  app.get('/api/project', async (req, res) => {
    return projectsRequestHandler.get(req, res);
  });

  app.get('/api/project/_metrics', query('id').notEmpty(), async (req: Request, res) => {
    return projectsRequestHandler.metrics(req, res);
  });

  app.get('/api/project/_failed_tags', query('id').notEmpty(), async (req: Request, res) => {
    return projectsRequestHandler.getFailedTags(req, res);
  });

  app.get('/api/project/_data', query('id').notEmpty(), async (req: Request, res) => {
    return projectsRequestHandler.getData(req, res);
  });
}