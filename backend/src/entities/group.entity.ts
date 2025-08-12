import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  ManyToOne,
  OneToMany,
  Unique,
} from 'typeorm';
import { User } from './user.entity';
import { GroupMember } from './group-member.entity';

@Entity()
@Unique(['invitationCode'])
export class Group {
  @PrimaryGeneratedColumn()
  id!: number;

  @Column()
  name!: string;

  @Column()
  invitationCode!: string;

  @ManyToOne(() => User, { eager: true })
  owner!: User;

  @OneToMany(() => GroupMember, (member) => member.group)
  members!: GroupMember[];
}
