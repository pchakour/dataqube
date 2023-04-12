"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const elasticsearch_1 = require("@elastic/elasticsearch");
const rules_service_1 = require("./services/rules_service");
const rules_1 = require("./routes/rules");
const projects_1 = require("./routes/projects");
const rules_request_handler_1 = require("./request_handlers/rules_request_handler");
const projects_request_handler_1 = require("./request_handlers/projects_request_handler");
const cors_1 = __importDefault(require("cors"));
const projects_service_1 = require("./services/projects_service");
const PORT = process.env.PORT || 3001;
const app = (0, express_1.default)();
app.use((0, cors_1.default)());
app.use(express_1.default.json());
app.use(express_1.default.urlencoded({ extended: true }));
const esClient = new elasticsearch_1.Client({
    node: 'http://localhost:9200',
});
app.listen(PORT, () => {
    console.log(`Server listening on ${PORT}`);
});
async function start() {
    const rulesService = new rules_service_1.RulesService();
    const projectsService = new projects_service_1.ProjectsService();
    const rulesServiceStart = await rulesService.start(esClient);
    const projectsServiceStart = await projectsService.start(esClient);
    const rulesRequestHandler = new rules_request_handler_1.RulesRequestHandler({ rulesService: rulesServiceStart });
    const projectsRequestHandler = new projects_request_handler_1.ProjectsRequestHandler({ projectsService: projectsServiceStart });
    (0, rules_1.addRoutes)(app, rulesRequestHandler);
    (0, projects_1.addRoutes)(app, projectsRequestHandler);
}
start();
