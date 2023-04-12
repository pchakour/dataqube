"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.addRoutes = void 0;
function addRoutes(app, rulesRequestHandler) {
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
exports.addRoutes = addRoutes;
