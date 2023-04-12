import { MappingTypeMapping } from '@elastic/elasticsearch/lib/api/types';

export const mappings: MappingTypeMapping = {
  properties: {
    name: {
      type: 'keyword',
    },
    rules: {
      type: 'text'
    }
  }
}
