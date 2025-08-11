import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';
import { PollOption } from './poll-option.entity';

@Entity()
export class Poll {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  question: string;

  @Column({ nullable: true })
  groupId: string;

  @OneToMany(() => PollOption, (option) => option.poll, { cascade: true })
  options: PollOption[];
}
