"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ProjectsRequestHandler = void 0;
class ProjectsRequestHandler {
    constructor({ projectsService }) {
        this.projectsService = projectsService;
    }
    async save(req, res) {
        const name = req.body.name;
        const rules = req.body.rules;
        await this.projectsService.save({
            name,
            rules
        });
    }
    async search(req, res) {
        const projects = await this.projectsService.search();
        return res.send(projects);
    }
    async get(req, res) {
        const project = await this.projectsService.search({
            size: 1,
            query: {
                term: {
                    _id: req.query.id,
                }
            },
        });
        return res.send(project[0]);
    }
    async metrics(req, res) {
        const metrics = await this.projectsService.getMetrics(req.query.id);
        return res.send(metrics);
    }
    async getFailedTags(req, res) {
        const failedTags = await this.projectsService.getFailedTags(req.query.id);
        return res.send(failedTags);
    }
    async getData(req, res) {
        const data = await this.projectsService.getData(req.query.id);
        return res.send(data);
    }
}
exports.ProjectsRequestHandler = ProjectsRequestHandler;
