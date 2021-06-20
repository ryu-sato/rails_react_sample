import React from 'react';
import { useTranslation } from 'react-i18next';

interface i18nSampleProps {
}

const I18nSample = (props: i18nSampleProps): JSX.Element => {
  const { t, i18n } = useTranslation();
  return(
    <>
      {t('Welcome to React')}
    </>
  )
};

export default I18nSample;
