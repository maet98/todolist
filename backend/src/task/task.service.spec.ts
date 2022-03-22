import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken, TypeOrmModule } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Status, Task } from './entities/task.entity';
import { TaskService } from './task.service';
import * as sinon from 'sinon';


describe('TaskService', () => {
  let service: TaskService;

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      imports: [TypeOrmModule.forFeature([Task])],
      providers: [TaskService],
    }).compile();

    service = await module.get<TaskService>(TaskService);
  });

  it('should get all open task',() => {
    var open = Status.OPEN;
    return service.findByStatus(open).then((tasks) => {
      console.log(tasks)
      tasks.forEach(task => {
        expect(task.status).toEqual(open);
      })
    });
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });
});
