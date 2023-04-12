"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.addRoutes = void 0;
const express_validator_1 = require("express-validator");
function addRoutes(app, projectsRequestHandler) {
    app.put('/api/projects', async (req, res) => {
        return projectsRequestHandler.save(req, res);
    });
    app.get('/api/projects', async (req, res) => {
        return projectsRequestHandler.search(req, res);
    });
    app.get('/api/project', async (req, res) => {
        return projectsRequestHandler.get(req, res);
    });
    app.get('/api/project/_metrics', (0, express_validator_1.query)('id').notEmpty(), async (req, res) => {
        return projectsRequestHandler.metrics(req, res);
    });
    app.get('/api/project/_failed_tags', (0, express_validator_1.query)('id').notEmpty(), async (req, res) => {
        return projectsRequestHandler.getFailedTags(req, res);
    });
    app.get('/api/project/_data', (0, express_validator_1.query)('id').notEmpty(), async (req, res) => {
        return projectsRequestHandler.getData(req, res);
    });
}
exports.addRoutes = addRoutes;
