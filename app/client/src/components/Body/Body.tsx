import { Link, Text, Box, Flex } from '@chakra-ui/react';
import { Link as ReachLink } from '@reach/router';
import React, { Fragment } from 'react';
import './Body.css';

export interface Sidenav {
  [category:string]: Array<{
    id: string;
    title: string;
    path: string;
  }>
}

interface BodyProps {
  children: React.ReactNode;
  sidenav?: Sidenav;
  style?: React.CSSProperties;
}

export function Body({ children, sidenav, style }: BodyProps) {
  return (
    <div style={style} className="body">
      <Flex>
        {sidenav &&
          <Box w="250px" flexGrow={0} className="sidenav">
            <nav>
              {
                Object.keys(sidenav).map((category) => (
                  <Fragment key={category}>
                    <Text as="b" color="blue.400">{category}</Text>
                    <div>
                      {
                        sidenav[category].map((link) => (
                          <Link key={link.id} as={ReachLink} to={link.path}>{link.title}</Link>
                        ))
                      }
                    </div>
                  </Fragment>
                ))
              }
            </nav>
          </Box>
        }
        <Box flexGrow={1}>
        {children}
        </Box>
      </Flex>
    </div>
  );
}