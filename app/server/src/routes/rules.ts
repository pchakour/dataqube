import { Express } from 'express';
import { RulesRequestHandler } from 'src/request_handlers/rules_request_handler';

export function addRoutes(app: Express, rulesRequestHandler: RulesRequestHandler) {
  app.put('/api/rules', async (req, res) => {
    return rulesRequestHandler.save(req, res);
  });

  app.get('/api/rules', async (req, res) => {
    return rulesRequestHandler.search(req, res);
  });

  app.get('/api/rule', async (req, res) => {
    return rulesRequestHandler.get(req, res);
  });
}