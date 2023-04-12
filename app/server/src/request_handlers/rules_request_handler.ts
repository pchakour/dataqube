import { Request, Response } from 'express';
import { IRulesServiceStart } from 'src/services/rules_service';

interface IServices {
  rulesService: IRulesServiceStart;
}

export class RulesRequestHandler {
  private rulesService: IServices['rulesService'];

  constructor({ rulesService }: IServices) {
    this.rulesService = rulesService;
  }

  public async save(req: Request, res: Response) {
    const name = req.body.name;
    const rules = req.body.rules;
    await this.rulesService.save({
      name,
      rules
    });

    res.send('OK');
  }

  public async search(req: Request, res: Response) {
    const rules = await this.rulesService.search();
    return res.send(rules);
  }

  public async get(req: Request, res: Response) {
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
