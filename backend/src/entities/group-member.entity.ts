import { Entity, PrimaryGeneratedColumn, ManyToOne, Column, Unique } from 'typeorm';
import { User } from './user.entity';
import { Group } from './group.entity';

@Entity()
@Unique(['user', 'group'])
export class GroupMember {
  @PrimaryGeneratedColumn()
  id!: number;

  @ManyToOne(() => User, { eager: true })
  user!: User;

  @ManyToOne(() => Group, (group) => group.members)
  group!: Group;

  @Column()
  role!: string;
}
