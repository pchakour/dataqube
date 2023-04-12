"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.RulesService = void 0;
const rules_1 = require("../../mappings/rules");
const lodash_1 = __importDefault(require("lodash"));
const INDEX = 'rules';
class RulesService {
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
        this.save = async (rules) => {
            await this.esClient.index({
                index: INDEX,
                document: Object.assign({}, rules)
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
    }
    setup() { }
    async start(esClient) {
        this.esClient = esClient;
        await this.createIndex();
        return {
            save: this.save,
            search: this.search,
        };
    }
}
exports.RulesService = RulesService;
