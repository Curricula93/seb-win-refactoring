/*
 * Copyright (c) 2026 ETH Zürich, IT Services
 * 
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 */

using SafeExamBrowser.Core.Contracts.OperationModel;
using SafeExamBrowser.Core.Contracts.OperationModel.Events;
using SafeExamBrowser.I18n.Contracts;
using SafeExamBrowser.Logging.Contracts;
using SafeExamBrowser.Monitoring.Contracts.Display;
using SafeExamBrowser.UserInterface.Contracts.Shell;

namespace SafeExamBrowser.Client.Operations
{
	internal class DisplayMonitorOperation : ClientOperation
	{
		private readonly IDisplayMonitor displayMonitor;
		private readonly ILogger logger;
		private readonly ITaskbar taskbar;

		public override event StatusChangedEventHandler StatusChanged;

		public DisplayMonitorOperation(ClientContext context, IDisplayMonitor displayMonitor, ILogger logger, ITaskbar taskbar) : base(context)
		{
			this.displayMonitor = displayMonitor;
			this.logger = logger;
			this.taskbar = taskbar;
		}

		public override OperationResult Perform()
		{
			logger.Info("OVERRIDE: Initializing working area to accommodate both SEB and Windows taskbars...");
			StatusChanged?.Invoke(TextKey.OperationStatus_InitializeWorkingArea);

			// Calculate space needed for SEB taskbar + Windows taskbar (approximately 40px for Windows taskbar)
			var sebTaskbarHeight = Context.Settings.UserInterface.Taskbar.EnableTaskbar ? taskbar.GetAbsoluteHeight() : 0;
			var windowsTaskbarHeight = 40; // Approximate Windows taskbar height
			var totalReservedHeight = sebTaskbarHeight + windowsTaskbarHeight;

			logger.Info($"Reserving {totalReservedHeight}px total: {sebTaskbarHeight}px for SEB taskbar + {windowsTaskbarHeight}px for Windows taskbar");
			
			displayMonitor.InitializePrimaryDisplay(totalReservedHeight);
			displayMonitor.StartMonitoringDisplayChanges();

			return OperationResult.Success;
		}

		public override OperationResult Revert()
		{
			logger.Info("Restoring working area to original state...");
			StatusChanged?.Invoke(TextKey.OperationStatus_RestoreWorkingArea);

			displayMonitor.StopMonitoringDisplayChanges();
			displayMonitor.ResetPrimaryDisplay();

			return OperationResult.Success;
		}
	}
}
