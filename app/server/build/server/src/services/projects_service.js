"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.ProjectsService = void 0;
const rules_1 = require("../../mappings/rules");
const lodash_1 = __importDefault(require("lodash"));
const uuid_1 = require("uuid");
const INDEX = 'projects';
class ProjectsService {
    constructor() {
        this.createIndex = async () => {
            if (!(await this.esClient.indices.exists({ index: INDEX }))) {
                await this.esClient.indices.create({
                    index: INDEX,
                    wait_for_active_shards: 1,
                    mappings: rules_1.mappings,
                });
            }
        };
        this.save = async (project) => {
            await this.esClient.index({
                index: INDEX,
                id: (0, uuid_1.v4)(),
                document: Object.assign({}, project)
            });
        };
        this.search = async (params) => {
            const response = await this.esClient.search(Object.assign({ index: INDEX, size: 10000 }, (params || {})));
            return lodash_1.default.compact(response.hits.hits.map(hit => {
                var _a, _b;
                return ({
                    id: hit._id,
                    name: (_a = hit._source) === null || _a === void 0 ? void 0 : _a.name,
                    rules: (_b = hit._source) === null || _b === void 0 ? void 0 : _b.rules,
                });
            }));
        };
        this.getMetrics = async (projectId) => {
            const dataProjectIndex = `data-${projectId}-*`;
            const countFailed = await this.esClient.count({
                index: dataProjectIndex,
                query: {
                    exists: {
                        field: "_dataqube.quality"
                    }
                }
            });
            const count = await this.esClient.count({
                index: dataProjectIndex,
            });
            return {
                count: count.count,
                failed: countFailed.count,
            };
        };
        this.getFailedTags = async (projectId) => {
            var _a;
            const response = await this.esClient.search({
                index: `data-${projectId}-*`,
                size: 0,
                aggs: {
                    dataqube: {
                        terms: { "field": "_dataqube.quality.rule_tag.keyword" }
                    }
                }
            });
            return ((_a = response.aggregations) === null || _a === void 0 ? void 0 : _a.dataqube.buckets) || [];
        };
        this.getData = async (projectId) => {
            const response = await this.esClient.search({
                index: `data-${projectId}-*`,
                size: 10000,
            });
            return response.hits;
        };
    }
    setup() { }
    async start(esClient) {
        this.esClient = esClient;
        await this.createIndex();
        return {
            save: this.save,
            search: this.search,
            getMetrics: this.getMetrics,
            getFailedTags: this.getFailedTags,
            getData: this.getData,
        };
    }
}
exports.ProjectsService = ProjectsService;
