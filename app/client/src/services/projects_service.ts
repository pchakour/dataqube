import { IProjectModel } from '../../../common/model/project_model';
import { IProjectMetrics } from '../../../common/types';

const endpointUrl = 'http://localhost:3001';

export class ProjectsService {
  public save(project: IProjectModel) {
    return fetch(`${endpointUrl}/api/projects`, {
      method: 'PUT',
      mode: "cors",
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ ...project }),
    });
  }

  public async get(projectId: string) {
    const response = await fetch(`${endpointUrl}/api/project?id=${projectId}`, {
      method: 'GET',
      mode: 'cors',
    });

    return response.json();
  }

  public async search(): Promise<IProjectModel[]> {
    const response = await fetch(`${endpointUrl}/api/projects`, {
      method: 'GET',
      mode: 'cors',
    });

    return response.json();
  }

  public async getMetrics(projectId: string): Promise<IProjectMetrics> {
    const response = await fetch(`${endpointUrl}/api/project/_metrics?id=${projectId}`, {
      method: 'GET',
      mode: 'cors',
    });

    return response.json();
  }

  public async getFailedTags(projectId: string) {
    const response = await fetch(`${endpointUrl}/api/project/_failed_tags?id=${projectId}`, {
      method: 'GET',
      mode: 'cors',
    });

    return response.json();
  }

  public async getData(projectId: string) {
    const response = await fetch(`${endpointUrl}/api/project/_data?id=${projectId}`, {
      method: 'GET',
      mode: 'cors',
    });

    return response.json();
  }
}