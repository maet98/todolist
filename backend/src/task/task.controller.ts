import { Controller, Get, Post, Body, Patch, Param, Delete, BadRequestException, Put } from '@nestjs/common';
import { TaskService } from './task.service';
import { CreateTaskDto } from './dto/create-task.dto';
import { UpdateTaskDto } from './dto/update-task.dto';
import { Status, Task } from './entities/task.entity';

@Controller('task')
export class TaskController {
  constructor(private taskService: TaskService) {}

  @Post()
  async create(@Body() task: Task) {
    const savedTask: Task =  await this.taskService.create(task);
    return savedTask;
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
  async findByStatus(@Param('status') status: Status) {
    if (Object.keys(Status).includes(status)) {
      return await this.taskService.findByStatus(status);
    } else {
      throw new BadRequestException(`${status} status is not found.`);
    }
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
