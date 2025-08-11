import { Entity, PrimaryGeneratedColumn, Column, OneToMany } from 'typeorm';
import { Preference } from './preference.entity';

@Entity()
export class User {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ unique: true })
  email: string;

  @Column()
  nickname: string;

  @Column()
  socialProvider: string;

  @OneToMany(() => Preference, (preference) => preference.user)
  preferences: Preference[];
}
