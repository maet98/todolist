import { Controller, Get, Post, Body, Patch, Param, Delete, BadRequestException, Put } from '@nestjs/common';
import { TaskService } from './task.service';
import { CreateTaskDto } from './dto/create-task.dto';
import { UpdateTaskDto } from './dto/update-task.dto';
import { Task } from './entities/task.entity';

@Controller('task')
export class TaskController {
  constructor(private taskService: TaskService) {}

  @Post()
  async create(@Body() task: Task) {
    try {
      const savedTask: Task =  await this.taskService.create(task);
      return savedTask;
    } catch(exception) {
      throw new BadRequestException(exception)
    }

  }

  @Get()
  async findAll() {
    return await this.taskService.findAll();
  }


  @Get("last")
  async getLastTask() {
    return await this.taskService.getLastTask();
  }

  @Get("status/:status")
  async findByStatus(@Param('status') status: String) {
    return await this.taskService.findByStatus(status);
  }


  @Get(':id')
  async findOne(@Param('id') id: number) {
    const task : Task = await this.taskService.findOne(id);
    if(task === undefined) {
      throw new BadRequestException("Task not found.")
    }
    return task;
  }

  @Put(':id')
  async update(@Param('id') id: String, @Body() task: Task) {
    task.id = Number(id)
    return await this.taskService.update(task);
  }

  @Delete(':id')
  async remove(@Param('id') id: number) {
    return await this.taskService.delete(+id);
  }
}
