import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';
import { IsEnum, IsIn } from 'class-validator';

export enum Status {
  OPEN = 'OPEN',
  IN_PROGRESS = 'IN_PROGRESS',
  DONE = 'DONE'
}

@Entity()
export class Task {
    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    title: String;

    @Column({type: 'datetime'})
    due: string;

    @Column({ default: Status.OPEN})
    @IsEnum(Status)
    status?: Status;
}
