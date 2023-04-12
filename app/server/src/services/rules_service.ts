import { Client } from '@elastic/elasticsearch';
import { IRulesModel } from '../../../common/model/rules_model';
import { mappings } from '../../mappings/rules';
import _ from 'lodash';
import { SearchRequest } from '@elastic/elasticsearch/lib/api/types';

const INDEX = 'rules';

export interface IRulesServiceStart {
  save: (rules: IRulesModel) => Promise<void>;
  search: (params?: SearchRequest) => Promise<IRulesModel[]>;
}

export class RulesService {
  private esClient!: Client;

  public setup() {}

  public async start(esClient: Client): Promise<IRulesServiceStart> {
    this.esClient = esClient;
    await this.createIndex();

    return {
      save: this.save,
      search: this.search,
    };
  }

  private createIndex = async () => {
    if (!(await this.esClient.indices.exists({ index: INDEX }))) {
      await this.esClient.indices.create({
        index: INDEX,
        wait_for_active_shards: 1,
        mappings,
      });
    }
  }

  private save = async (rules: IRulesModel) => {
    await this.esClient.index({
      index: INDEX,
      document: {
        ...rules
      }
    });
  };

  private search = async (params?: SearchRequest): Promise<IRulesModel[]> => {
    const response = await this.esClient.search<IRulesModel>({
      index: INDEX,
      size: 10000,
      ...(params || {}),
    });

    return _.compact(response.hits.hits.map(hit => ({
      id: hit._id,
      name: hit._source?.name!,
      rules: hit._source?.rules!,
    })));
  };

}