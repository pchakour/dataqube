import { useContext } from 'react';
import { ServicesContext } from '../App';

export function useServices() {
  const services = useContext(ServicesContext);
  return services;
}