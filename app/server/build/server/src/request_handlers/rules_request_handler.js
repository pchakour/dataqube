"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.RulesRequestHandler = void 0;
class RulesRequestHandler {
    constructor({ rulesService }) {
        this.rulesService = rulesService;
    }
    async save(req, res) {
        const name = req.body.name;
        const rules = req.body.rules;
        await this.rulesService.save({
            name,
            rules
        });
        res.send('OK');
    }
    async search(req, res) {
        const rules = await this.rulesService.search();
        return res.send(rules);
    }
    async get(req, res) {
        const rules = await this.rulesService.search({
            size: 1,
            query: {
                term: {
                    _id: req.query.id,
                }
            },
        });
        return res.send(rules[0]);
    }
}
exports.RulesRequestHandler = RulesRequestHandler;
