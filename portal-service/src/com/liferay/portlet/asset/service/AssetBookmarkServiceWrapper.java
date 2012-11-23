/**
 * Copyright (c) 2000-2012 Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */

package com.liferay.portlet.asset.service;

import com.liferay.portal.service.ServiceWrapper;

/**
 * <p>
 * This class is a wrapper for {@link AssetBookmarkService}.
 * </p>
 *
 * @author    Brian Wing Shun Chan
 * @see       AssetBookmarkService
 * @generated
 */
public class AssetBookmarkServiceWrapper implements AssetBookmarkService,
	ServiceWrapper<AssetBookmarkService> {
	public AssetBookmarkServiceWrapper(
		AssetBookmarkService assetBookmarkService) {
		_assetBookmarkService = assetBookmarkService;
	}

	/**
	* Returns the Spring bean ID for this bean.
	*
	* @return the Spring bean ID for this bean
	*/
	public java.lang.String getBeanIdentifier() {
		return _assetBookmarkService.getBeanIdentifier();
	}

	/**
	* Sets the Spring bean ID for this bean.
	*
	* @param beanIdentifier the Spring bean ID for this bean
	*/
	public void setBeanIdentifier(java.lang.String beanIdentifier) {
		_assetBookmarkService.setBeanIdentifier(beanIdentifier);
	}

	public com.liferay.portlet.asset.model.AssetBookmark addAssetBookmark(
		long groupId, long userId, java.lang.String className, long classPK)
		throws com.liferay.portal.kernel.exception.PortalException,
			com.liferay.portal.kernel.exception.SystemException {
		return _assetBookmarkService.addAssetBookmark(groupId, userId,
			className, classPK);
	}

	public void deleteAssetBookmark(long userId, long classPK)
		throws com.liferay.portal.kernel.exception.PortalException,
			com.liferay.portal.kernel.exception.SystemException {
		_assetBookmarkService.deleteAssetBookmark(userId, classPK);
	}

	public boolean isFavorite(long userId, java.lang.String className,
		long classPK)
		throws com.liferay.portal.kernel.exception.SystemException {
		return _assetBookmarkService.isFavorite(userId, className, classPK);
	}

	/**
	 * @deprecated Renamed to {@link #getWrappedService}
	 */
	public AssetBookmarkService getWrappedAssetBookmarkService() {
		return _assetBookmarkService;
	}

	/**
	 * @deprecated Renamed to {@link #setWrappedService}
	 */
	public void setWrappedAssetBookmarkService(
		AssetBookmarkService assetBookmarkService) {
		_assetBookmarkService = assetBookmarkService;
	}

	public AssetBookmarkService getWrappedService() {
		return _assetBookmarkService;
	}

	public void setWrappedService(AssetBookmarkService assetBookmarkService) {
		_assetBookmarkService = assetBookmarkService;
	}

	private AssetBookmarkService _assetBookmarkService;
}