import React from 'react';

interface FacilitySearchProps {
  className?: string;
}

const FacilitySearch = ({ className }: FacilitySearchProps) => {
  return (
    <div tw="flex flex-col" className={className}>
      <h1>FacilitySearch</h1>
    </div>
  );
};

FacilitySearch.defaultProps = {
  className: null,
};

export { FacilitySearch };
