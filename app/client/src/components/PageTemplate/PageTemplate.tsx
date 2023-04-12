import { Heading, Spacer } from '@chakra-ui/react';
import React from 'react'
import { Body, Sidenav } from '../Body/Body';
import { Footer } from '../Footer/Footer';
import { Header } from '../Header/Header';

interface PageTemplateProps {
  children: React.ReactNode;
  sidenav?: Sidenav;
  marginTop?: number | string;
  marginBottom?: number | string;
  title?: string;
  select?: string;
  rightButtons?: React.ReactElement[];
}

export function PageTemplate({
  children,
  sidenav,
  marginBottom,
  marginTop,
  title,
  select,
  rightButtons,
}: PageTemplateProps) {
  const bodyStyle: React.CSSProperties = {};

  if (!sidenav) {
    bodyStyle.margin = 'auto';
    bodyStyle.width = '70%';

    if (marginBottom) {
      bodyStyle.paddingBottom = Number.isInteger(marginBottom) ? `${marginBottom}px` : marginBottom;
    }

    if (marginTop) {
      bodyStyle.paddingTop = Number.isInteger(marginTop) ? `${marginTop}px` : marginTop;
    }
  }

  return (
    <div className='pageTemplage'>
      <Header select={select} />
      <Body style={bodyStyle} sidenav={sidenav}>
        {title &&
          <>
            <Heading as='h1' size='lg'>{title}</Heading>
            <Spacer padding={5} />
            {
              (rightButtons || []).map((rightButton) => rightButton)
            }
          </>
        }
        {children}
      </Body>
      <Footer />
    </div>
  );
}
