import { IRulesModel } from '../../../common/model/rules_model';

const endpointUrl = 'http://localhost:3001';

export class RulesService {
  public save(rules: IRulesModel) {
    return fetch(`${endpointUrl}/api/rules`, {
      method: 'PUT',
      mode: "cors",
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ ...rules }),
    });
  }

  public async search(): Promise<IRulesModel[]> {
    const response = await fetch(`${endpointUrl}/api/rules`, {
      method: 'GET',
      mode: 'cors',
    });

    return response.json();
  }
}