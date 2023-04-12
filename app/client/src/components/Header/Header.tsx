import React from 'react';
import { Box, Link } from '@chakra-ui/react';
import './Header.css'
import { Link as ReachLink } from '@reach/router';

export interface NavigationLink {
  id: string;
  title: string;
  page: string;
}

const navigation: NavigationLink[] = [
  {
    id: 'home',
    title: 'Home',
    page: '/'
  },
  {
    id: 'projects',
    title: 'Projects',
    page: '/projects'
  },
  {
    id: 'rules',
    title: 'Rules',
    page: '/rules'
  },
];

interface HeaderProps {
  select?: string;
}

export function Header({ select }: HeaderProps) {
  return (
    <Box className="header" w="100%" p={4} color="white">
      <nav>
        {navigation.map((link) => (
          <Link className={link.id === select ? 'selected' : ''} key={link.id} as={ReachLink} to={link.page}>
            {' '}{link.title}
          </Link>
        ))}
      </nav>
    </Box>
  );
}