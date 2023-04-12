import { Request, Response } from 'express';
import { IProjectsServiceStart } from 'src/services/projects_service';

interface IServices {
  projectsService: IProjectsServiceStart;
}

export class ProjectsRequestHandler {
  private projectsService: IServices['projectsService'];

  constructor({ projectsService }: IServices) {
    this.projectsService = projectsService;
  }

  public async save(req: Request, res: Response) {
    const name = req.body.name;
    const rules = req.body.rules;
    await this.projectsService.save({
      name,
      rules
    });
  }

  public async search(req: Request, res: Response) {
    const projects = await this.projectsService.search();
    return res.send(projects);
  }

  public async get(req: Request, res: Response) {
    const project = await this.projectsService.search({
      size: 1,
      query: {
        term: {
          _id: req.query.id,
        }
      },
    });

    return res.send(project[0]);
  }

  public async metrics(req: Request, res: Response) {
    const metrics = await this.projectsService.getMetrics(req.query.id as string);
    return res.send(metrics);
  }

  public async getFailedTags(req: Request, res: Response) {
    const failedTags = await this.projectsService.getFailedTags(req.query.id as string);
    return res.send(failedTags);
  }

  public async getData(req: Request, res: Response) {
    const data = await this.projectsService.getData(req.query.id as string);
    return res.send(data);
  }
}
