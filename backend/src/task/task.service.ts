import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { CreateTaskDto } from './dto/create-task.dto';
import { UpdateTaskDto } from './dto/update-task.dto';
import { UpdateResult, DeleteResult } from  'typeorm';
import { Task } from './entities/task.entity';

@Injectable()
export class TaskService {
  constructor(
    @InjectRepository(Task)
    private taskRepository: Repository<Task>
  ) {}

  async findByStatus(status: String): Promise<Task[]> {
    return await this.taskRepository.query(`select * from task where status='${status}'`);
  }

  async getLastTask(): Promise<Task[]> {
    return await this.taskRepository.query("select * from task where status<>'COMPLETED' order by due limit 3");
  }

  async findAll(): Promise<Task[]> {
    return await this.taskRepository.find();
  }

  async findOne(id: number): Promise<Task> {
    return await this.taskRepository.findOne(id);
  }

  async  create(task: Task): Promise<Task> {
    return await this.taskRepository.save(task);
  }

  async update(task: Task): Promise<Task> {
    await this.taskRepository.update(task.id, task);
    return task;
  }

  async delete(id): Promise<DeleteResult> {
    return await this.taskRepository.delete(id);
  }
}
