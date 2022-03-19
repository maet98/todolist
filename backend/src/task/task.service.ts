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

  async  findAll(): Promise<Task[]> {
    return await this.taskRepository.find();
  }

  async findOne(id: number): Promise<Task> {
    return await this.taskRepository.findOne(id);
  }

  async  create(task: Task): Promise<Task> {
    return await this.taskRepository.save(task);
  }

  async update(task: Task): Promise<UpdateResult> {
    return await this.taskRepository.update(task.id, task);
  }

  async delete(id): Promise<DeleteResult> {
    return await this.taskRepository.delete(id);
  }
}
