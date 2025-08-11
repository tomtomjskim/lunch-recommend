import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, OneToMany } from 'typeorm';
import { User } from './user.entity';
import { GroupMember } from './group-member.entity';

@Entity()
export class Group {
  @PrimaryGeneratedColumn()
  id!: number;

  @Column()
  name!: string;

  @Column({ unique: true })
  invitationCode!: string;

  @ManyToOne(() => User, { eager: true })
  owner!: User;

  @OneToMany(() => GroupMember, (member) => member.group)
  members!: GroupMember[];
}
