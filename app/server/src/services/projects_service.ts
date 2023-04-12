import { Client } from '@elastic/elasticsearch';
import { IProjectModel } from '../../../common/model/project_model';
import { mappings } from '../../mappings/rules';
import _ from 'lodash';
import { SearchHitsMetadata, SearchRequest } from '@elastic/elasticsearch/lib/api/types';
import { v4 as uuidv4 } from 'uuid';
import { IProjectMetrics } from '../../../common/types';

const INDEX = 'projects';

export interface IProjectsServiceStart {
  save: (project: IProjectModel) => Promise<void>;
  search: (params?: SearchRequest) => Promise<IProjectModel[]>;
  getMetrics: (projectId: string) => Promise<IProjectMetrics>;
  getFailedTags: (projectId: string) => Promise<any[]>;
  getData: (projectId: string) => Promise<SearchHitsMetadata>;
}

export class ProjectsService {
  private esClient!: Client;

  public setup() { }

  public async start(esClient: Client): Promise<IProjectsServiceStart> {
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

  private createIndex = async () => {
    if (!(await this.esClient.indices.exists({ index: INDEX }))) {
      await this.esClient.indices.create({
        index: INDEX,
        wait_for_active_shards: 1,
        mappings,
      });
    }
  }

  private save = async (project: IProjectModel) => {
    await this.esClient.index({
      index: INDEX,
      id: uuidv4(),
      document: {
        ...project
      }
    });
  };

  private search = async (params?: SearchRequest): Promise<IProjectModel[]> => {
    const response = await this.esClient.search<IProjectModel>({
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

  private getMetrics = async (projectId: string): Promise<IProjectMetrics> => {
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
    }
  }

  private getFailedTags = async (projectId: string) => {
    const response = await this.esClient.search<unknown, Record<'dataqube', any>>({
      index: `data-${projectId}-*`,
      size: 0,
      aggs: {
        dataqube: {
          terms: { "field": "_dataqube.quality.rule_tag.keyword" }
        }
      }
    });

    return response.aggregations?.dataqube.buckets || [];
  }

  private getData = async (projectId: string) => {
    const response = await this.esClient.search<unknown, Record<'dataqube', any>>({
      index: `data-${projectId}-*`,
      size: 10000,
    });

    return response.hits;
  }
}